#pragma once

#include <atomic>
#include <type_traits>

#include <ev.h>

#include <engine/ev/intrusive_refcounted_base.hpp>
#include <engine/ev/thread_control.hpp>

#include <utils/assert.hpp>

namespace engine::ev {

/// Watcher type for a particular event type. Not intended for ownage by
/// intrusive_ptr.
template <typename EvType>
class Watcher final : private IntrusiveRefcountedBase {
 public:
  template <typename Obj>
  Watcher(const ThreadControl& thread_control, Obj* data);
  // NOLINTNEXTLINE(bugprone-exception-escape)
  ~Watcher() final;

  void Init(void (*cb)(struct ev_loop*, ev_async*, int) noexcept);
  void Init(void (*cb)(struct ev_loop*, ev_io*, int) noexcept);
  void Init(void (*cb)(struct ev_loop*, ev_io*, int) noexcept, int fd,
            int events);  // TODO: use utils::Flags for events
  void Init(void (*cb)(struct ev_loop*, ev_timer*, int) noexcept,
            ev_tstamp after, ev_tstamp repeat);
  void Init(void (*cb)(struct ev_loop*, ev_idle*, int) noexcept);

  template <typename T = EvType>
  std::enable_if_t<std::is_same_v<T, ev_io>> Set(int fd, int events);

  template <typename T = EvType>
  std::enable_if_t<std::is_same_v<T, ev_timer>> Set(ev_tstamp after,
                                                    ev_tstamp repeat);

  /* Synchronously start/stop ev_xxx.  Can be used from coroutines only */
  void Start();
  void Stop();

  /* Asynchronously start ev_xxx. Must not block. */
  void StartAsync();

  /* Asynchronously stop ev_xxx. Beware of dangling references! */
  void StopAsync();

  template <typename T = EvType>
  std::enable_if_t<std::is_same_v<T, ev_timer>> Again();

  template <typename T = EvType>
  std::enable_if_t<std::is_same_v<T, ev_async>> Send();

 private:
  using EvLoopOpsCountingGuard = boost::intrusive_ptr<IntrusiveRefcountedBase>;

  void StartImpl();
  void StopImpl();

  template <typename T = EvType>
  std::enable_if_t<std::is_same_v<T, ev_timer>> AgainImpl();

  template <typename T = EvType>
  std::enable_if_t<std::is_same_v<T, ev_async>> SendImpl();

  template <void (Watcher::*func)()>
  void CallInEvLoop();

  static constexpr std::size_t kMinAsyncCounterValue = 1;
  bool HasPendingEvLoopOps() const noexcept {
    return use_count() != kMinAsyncCounterValue;
  }

  ThreadControl thread_control_;
  EvType w_;
  std::atomic<bool> is_running_;
};

template <typename EvType>
template <typename Obj>
Watcher<EvType>::Watcher(const ThreadControl& thread_control, Obj* data)
    : thread_control_(thread_control), is_running_(false) {
  w_.data = static_cast<void*>(data);

  // Don't delete this class via intrusive counter, because is is usually not
  // allocated dynamically. Use the counter only for couning EvLoop operations.
  intrusive_ptr_add_ref(this);
  UASSERT(use_count() == kMinAsyncCounterValue);
}

template <typename EvType>
Watcher<EvType>::~Watcher() {
  Stop();
  UASSERT(!HasPendingEvLoopOps());
}

template <typename EvType>
void Watcher<EvType>::Start() {
  CallInEvLoop<&Watcher::StartImpl>();
}

template <typename EvType>
void Watcher<EvType>::Stop() {
  if (!HasPendingEvLoopOps() && !is_running_) return;

  CallInEvLoop<&Watcher::StopImpl>();
}

template <typename EvType>
void Watcher<EvType>::StartAsync() {
  thread_control_.RunInEvLoopAsync(
      [](IntrusiveRefcountedBase& base) {
        auto& self = static_cast<Watcher&>(base);
        self.StartImpl();
      },
      EvLoopOpsCountingGuard{this});
}

template <typename EvType>
void Watcher<EvType>::StopAsync() {
  // no fetch_add in predicate is fine
  if (!HasPendingEvLoopOps() && !is_running_) return;

  thread_control_.RunInEvLoopAsync(
      [](IntrusiveRefcountedBase& base) {
        auto& self = static_cast<Watcher&>(base);
        self.StopImpl();
      },
      EvLoopOpsCountingGuard{this});
}

template <typename EvType>
template <typename T>
std::enable_if_t<std::is_same_v<T, ev_timer>> Watcher<EvType>::Again() {
  CallInEvLoop<&Watcher::AgainImpl>();
}

template <typename EvType>
template <typename T>
std::enable_if_t<std::is_same_v<T, ev_async>> Watcher<EvType>::Send() {
  ev_async_send(thread_control_.GetEvLoop(), &w_);
}

template <typename EvType>
template <void (Watcher<EvType>::*func)()>
void Watcher<EvType>::CallInEvLoop() {
  // We need guard here to make sure that ~Watcher() does not
  // return as long as we are calling Watcher::Stop or Watcher::Start from ev
  // thread.
  EvLoopOpsCountingGuard guard{this};
  thread_control_.RunInEvLoopSync([this] { (this->*func)(); });
}

}  // namespace engine::ev
