hotrod-core:
  environment:
    - HOTROD_SERVICE
{%- if http_proxy %}
    - HTTP_PROXY={{ http_proxy }}
{%- endif %}    
{%- if https_proxy %}
    - HTTPS_PROXY={{ https_proxy }}
{%- endif %} 

hotrod-service:
  environment:
    - HOTROD_SERVICE
{%- if http_proxy %}
    - HTTP_PROXY={{ http_proxy }}
{%- endif %}    
{%- if https_proxy %}
    - HTTPS_PROXY={{ https_proxy }}
{%- endif %}    
  labels:
    za.co.panoptix.hotrod.startorder: "2"
    za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"

