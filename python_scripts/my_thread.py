#! /usr/bin/python

import threading
import Queue
import time


def timeout(timeout_in_secs):
    """
    Decorator
    """
    def function_timeout(function):
        def wrapper(*args):
            def threaded_function(queue, function, *args):
                """
                Method to communicate with the actual "function" that needs
                to be handled. It will put the "function" return value in the
                queue so it can later be processed by the wrapper.
                """
                queue.put(function(*args))

            queue = Queue.Queue()
            thread = threading.Thread(target=threaded_function,
                                      args=((queue, function,) + args))
            # Don't kee the thread alive if the main thread has exited.
            thread.setDaemon(True)
            thread.start()
            thread.join(timeout_in_secs)
            if thread.isAlive():
                print ("[Decorator] Thread still alive after {0} secs. Wait "
                       "until it finishes.".format(timeout_in_secs))
                # Wait until thread finishes. Alternatively exit with
                # sys.exit(1)
                thread.join()
            else:
                print "[Decorator] Thread already finished."
            return queue.get()
        return wrapper
    return function_timeout


@timeout(2)
def my_sleep(sleep_time, return_str=True):
    time.sleep(sleep_time)
    if return_str:
        return "Sleep {0} second(s).".format(sleep_time)

if __name__ == "__main__":
    print my_sleep(1)
    print my_sleep(3)
    print my_sleep(1, False)
    print my_sleep(3, False)
