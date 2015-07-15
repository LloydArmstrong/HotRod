hotrod:
  environment:
    - HOTROD_SERVICE
{%- if http_proxy %}
    - HTTP_PROXY={{ http_proxy }}
{%- endif %}    
{%- if https_proxy %}
    - HTTPS_PROXY={{ https_proxy }}
{%- endif %}    
