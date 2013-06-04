# This the over state that get is all going.
#  
# salt-run state.over your_environment /<path to>overstate.sls

controller:
  match: 'all-in-one.*'

compute1:
  match: 'cpu000[1,2,3,4]*'
  require:
    - controller

compute2:
  match: 'cpu000[5,6,7,8,9]*'
  require:
    - controller
    - compute1

compute3:
  match: 'cpu001[0,1]*'
  require:
    - controller
    - compute1
    - compute2
