# AWS Cloudwatch Logs

# install package - on amazon linux
awslogs:
  pkg.installed

# Template - loops over all defined pillar entries
/etc/awslogs/awslogs.conf:
  file.managed:
    - source: salt://awslogs/files/awslogs.conf
    - template: jinja

## Append each logstream / file to the stock config
#{% for loggroup, args in pillar.get('awslogs', {}).items() %}
#awslogs-append-{{loggroup}}:
#  file.append: 
#    - name: /etc/awslogs/awslogs.conf
#    - text: |
#        [{{loggroup}}]
#        datetime_format = %b %d %H:%M:%S
#        file = {{ args['file'] }}
#        buffer_duration = 5000
#        log_stream_name = {instance_id}
#        initial_position = start_of_file
#        log_group_name = {{loggroup}}
#
#{% endfor %}

# Start service, restart on addition of services

awslogs-service:
  service:
    - name: awslogs
    - running
    - enable: True
    - watch:
      - file: /etc/awslogs/awslogs.conf
