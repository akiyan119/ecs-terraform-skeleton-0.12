#!/usr/bin/bash

find . -name log -type f -print0 | xargs -0 grep 'module.vpc.aws_vpc.{{ .Project }}-vpc: Creation'
find . -name log -type f -print0 | xargs -0 grep 'module.vpc.aws_subnet.{{ .Project }}-public-a: Creation'
find . -name log -type f -print0 | xargs -0 grep 'module.vpc.aws_subnet.{{ .Project }}-public-c: Creation'
find . -name log -type f -print0 | xargs -0 grep 'module.alb.aws_alb_target_group.{{ .Project }}-alb-tg: Creation'
find . -name log -type f -print0 | xargs -0 grep 'module.sg.aws_security_group.{{ .Project }}-ecs: Creation'

find . -name log -type f -print0 | xargs -0 grep 'module.vpc.aws_vpc.{{ .Project }}-vpc: Refreshing'
find . -name log -type f -print0 | xargs -0 grep 'module.vpc.aws_subnet.{{ .Project }}-public-a: Refreshing'
find . -name log -type f -print0 | xargs -0 grep 'module.vpc.aws_subnet.{{ .Project }}-public-c: Refreshing'
find . -name log -type f -print0 | xargs -0 grep 'module.alb.aws_alb_target_group.{{ .Project }}-alb-tg: Refreshing'
find . -name log -type f -print0 | xargs -0 grep 'module.sg.aws_security_group.{{ .Project }}-ecs: Refreshing'
