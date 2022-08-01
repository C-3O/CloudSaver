Rem  #STOP  ALL
Rem  ######DB###################
aws --no-verify-ssl rds describe-db-instances --query "DBInstances[]".DBInstanceIdentifier --output text > db_group.txt
FOR /F "tokens=1" %G IN (db_group.txt) DO   aws --no-verify-ssl  rds stop-db-instance --db-instance-identifier %G
Rem #####################################

Rem ######StartEC2###################
aws --no-verify-ssl  ec2 describe-instances  --filters "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value, InstanceId, PublicIpAddress, State.Name, StateTransitionReason]"  --output text > aws.txt
FOR /F "tokens=1,2" %G IN (aws.txt) DO   IF /I "%G"=="LifeRay-App-Server" ( aws --no-verify-ssl ec2 terminate-instances --instance-ids %H   )   ELSE  ( aws --no-verify-ssl ec2 stop-instances --instance-ids %H    )
Rem ###############################

Rem #############AutoScaling ##############

aws --no-verify-ssl autoscaling describe-auto-scaling-groups  --query AutoScalingGroups[].AutoScalingGroupName --output text > as_group.txt
FOR /F "tokens=1" %G IN (as_group.txt) DO   aws autoscaling suspend-processes --auto-scaling-group-name  %G
Rem ###################################################
