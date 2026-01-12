name "local_scheduler_role"
description "Local changes to scheduler"
run_list("recipe[local_scheduler::mariadb]")
