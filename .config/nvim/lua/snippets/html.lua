local ls = require("luasnip")
local s = ls.snippet       -- Define snippet
local t = ls.text_node     -- Static text
local i = ls.insert_node   -- Insertable placeholders
local f = ls.function_node -- Dynamic content
local c = ls.choice_node   -- Choice between options
local d = ls.dynamic_node  -- Nested dynamic nodes

return {
  s("block", { t("{% block "), i(1, "name"), t({ " %}", "  " }), i(2, "content"), t({ "", "{% endblock %}" }) }),
  s("if", { t("{% if "), i(1, "condition"), t({ " %}", "  " }), i(2, "content"), t({ "", "{% endif %}" }) }),
  s("ifel",
    { t("{% if "), i(1, "condition"), t({ " %}", "  " }), i(2, "true_content"), t({ "", "{% else %}", "  " }), i(3,
      "false_content"), t({ "", "{% endif %}" }) }),
  s("for",
    { t("{% for "), i(1, "item"), t(" in "), i(2, "list"), t({ " %}", "  " }), i(3, "content"), t({ "", "{% endfor %}" }) }),
  s("include", { t("{% include '"), i(1, "template.html"), t("' %}") }),
  s("extends", { t("{% extends '"), i(1, "base.html"), t("' %}") }),
  s("loadstatic", { t("{% load static %}") }),
  s("static", { t('<script src="{% static '), i(1, "path/to/file.js"), t('" %}"></script>') }),
  s("url", { t("{% url '"), i(1, "app_name:view_name"), t("' "), i(2, "args"), t(" %}") }),
  s("csrf", { t("{% csrf_token %}") }),
  s("form",
    { t('<form method="POST">'), t({ "", "  {% csrf_token %}" }), t({ "", "  " }), i(1, "{{ form.as_p }}"), t({ "",
      "  <button type='submit'>Submit</button>" }), t({ "", "</form>" }) }),
  s("messages",
    { t("{% if messages %}"), t({ "", "  <ul>" }), t({ "", "  {% for message in messages %}" }), t({ "",
      "    <li>{{ message }}</li>" }), t({ "", "  {% endfor %}" }), t({ "", "  </ul>" }), t({ "", "{% endif %}" }) }),
}
