import sys, sysconfig
sys.prefix = 'prefix-AAA'
sys.exec_prefix = 'exec-prefix-AAA'
v = sysconfig.get_config_vars()
print(v['prefix'], v['exec_prefix'], v['base'], v['platbase'])
