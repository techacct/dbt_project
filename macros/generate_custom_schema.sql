{% macro generate_schema_name(custom_schema_name, node) -%}
    {% set default_schema = target.schema %}
    {% set custom_schema = custom_schema_name or node.config.schema %}
    
    {% if custom_schema is none %}
        {{ default_schema }}
    {% else %}
        {{ custom_schema | trim }}
    {% endif %}
{%- endmacro %}
