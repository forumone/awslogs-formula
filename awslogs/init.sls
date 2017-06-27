# AWS Cloudwatch Logs
#
# install package - on amazon linux
awslogs:
  pkg.installed

# set role grains
set-awslogs-role:
  grains.list_present:
    - name: roles
    - value: awslogs
    - require:
      - pkg: awslogs

# Template - loops over all defined pillar entries
/etc/awslogs/awslogs.conf:
  file.managed:
    - source: salt://awslogs/files/awslogs.conf
    - template: jinja
    - require:
      - pkg: awslogs

/etc/awslogs/awscli.conf:
  file.managed:
    - source: salt://awslogs/files/awscli.conf
    - template: jinja
    - require:
      - pkg: awslogs

# Start service, restart on addition of services

awslogs-service:
  service:
    - name: awslogs
    - running
    - enable: True
    - watch:
      - file: /etc/awslogs/awslogs.conf
      - file: /etc/awslogs/awscli.conf
    - require:
      - pkg: awslogs
