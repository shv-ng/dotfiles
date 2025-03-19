
tom(){
    if [[ -z "$(rg tomlscript pyproject.toml )" ]]; then
        echo -e "\n[tool.tomlscript]"\
            "\ndev = \"uv run manage.py runserver\""\
            "\nmanage = \"uv run manage.py\""\
            "\nmigrate = \"uv run manage.py makemigrations && uv run manage.py migrate\""\
            "\nstartapp = \"uv run manage.py startapp\"">> pyproject.toml
    fi
    uvx tomlscript "$@"
}
