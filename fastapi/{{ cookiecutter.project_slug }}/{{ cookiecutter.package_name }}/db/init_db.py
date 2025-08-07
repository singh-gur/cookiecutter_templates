from {{ cookiecutter.package_name }}.db.session import init_db

def run():
    init_db()

if __name__ == "__main__":
    run()
