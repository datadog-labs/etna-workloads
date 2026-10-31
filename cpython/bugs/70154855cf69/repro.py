import sys, sysconfig
sys.prefix = 'prefix-AAA'
sys.exec_prefix = 'exec-prefix-AAA'
v = sysconfig.get_config_vars()
print(v['prefix'], v['exec_prefix'])
sys.prefix = 'prefix-BBB'
sys.exec_prefix = 'exec-prefix-BBB'
v = sysconfig.get_config_vars()
print(v['prefix'], v['base'], v['exec_prefix'], v['platbase'])
