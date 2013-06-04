base:
  '*':
    - packages
    - users

your_environment:
  '*':
    - packages
  'all-in-one*':
    - openstack.controller
  'cpu*':
    - openstack.compute
