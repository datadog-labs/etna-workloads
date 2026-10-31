import sys
try:
    sys.activate_stack_trampoline("perf_jit")
    print(sys.is_stack_trampoline_active())
    sys.deactivate_stack_trampoline()
    print(sys.is_stack_trampoline_active())
except Exception as e:
    print(type(e).__name__, e)
