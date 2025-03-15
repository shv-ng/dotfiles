
tom-init(){
echo -e "\n[tool.tomlscript]"\
  "\ndev = \"uv run manage.py runserver\""\
  "\nmigrate = \"uv run manage.py makemigrations && uv run manage.py migrate\""\
  "\nstartapp = \"uv run manage.py startapp\"">> pyproject.toml 
}

tom(){
  uvx tomlscript "$@"
}
