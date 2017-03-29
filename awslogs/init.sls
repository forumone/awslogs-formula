# AWS Cloudwatch Logs

# install package - on amazon linux
awslogs:
  pkg.installed

# Template - loops over all defined pillar entries
/etc/awslogs/awslogs.conf:
  file.managed:
    - source: salt://awslogs/files/awslogs.conf
    - template: jinja

/etc/awslogs/awscli.conf:
  file.managed:
    - source: salt://awslogs/files/awscli.conf
    - template: jinja

# Start service, restart on addition of services

awslogs-service:
  service:
    - name: awslogs
    - running
    - enable: True
    - watch:
      - file: /etc/awslogs/awslogs.conf
      - file: /etc/awslogs/awscli.conf
