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
      - awslogs

# Template - loops over all defined pillar entries
/etc/awslogs/awslogs.conf:
  file.managed:
    - source: salt://awslogs/files/awslogs.conf
    - template: jinja
    - require:
      - awslogs

/etc/awslogs/awscli.conf:
  file.managed:
    - source: salt://awslogs/files/awscli.conf
    - template: jinja
    - require:
      - awslogs

# Start service, restart on addition of services
{% if grains['osmajorrelease'] == '2018' %}
awslogs-service:
  service:
    - name: awslogs
    - running
    - enable: True
    - watch:
      - file: /etc/awslogs/awslogs.conf
      - file: /etc/awslogs/awscli.conf
    - require:
      - awslogs
{% elif grains['osmajorrelease'] == '2' %}
awslogs-service:
  service:
    - name: awslogsd
    - running
    - enable: True
    - watch:
      - file: /etc/awslogs/awslogs.conf
      - file: /etc/awslogs/awscli.conf
    - require:
      - awslogs
{% endif %}