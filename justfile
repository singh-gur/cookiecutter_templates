set shell := ["zsh", "-cu"]

# Cookiecutter template repository helpers.
#
# Common usage:
#   just list-templates
#   just render-fastapi /tmp/rendered_fastapi
#   just test-fastapi /tmp/rendered_fastapi
#   just render-prefect-flow /tmp/rendered_prefect
#   just test-prefect-flow /tmp/rendered_prefect

default:
    @just --list

# Show the template directories currently tracked in this repository.
list-templates:
    @printf '%s\n' fastapi prefect_flow

# Render the FastAPI template into {{output_dir}} using Cookiecutter prompts.
render-fastapi output_dir:
    uvx cookiecutter "{{justfile_directory()}}/fastapi" \
        --output-dir '{{output_dir}}'

# Run the generated FastAPI project's smoke test.
test-fastapi output_dir project_slug='my_fastapi_service':
    just --justfile '{{output_dir}}/{{project_slug}}/justfile' test

# Render the Prefect template into {{output_dir}} using Cookiecutter prompts.
render-prefect-flow output_dir:
    uvx cookiecutter "{{justfile_directory()}}/prefect_flow" \
        --output-dir '{{output_dir}}'

# Run the generated Prefect project's local smoke test.
test-prefect-flow output_dir project_slug='my_prefect_flow':
    just --justfile '{{output_dir}}/{{project_slug}}/justfile' run-local

# Convenience helper: render and smoke-test the FastAPI template in one go.
check-fastapi output_dir='/tmp/cookiecutter_fastapi_check' project_slug='my_fastapi_service' package_name='app' use_postgres='n':
    rm -rf '{{output_dir}}/{{project_slug}}'
    uvx cookiecutter "{{justfile_directory()}}/fastapi" --no-input \
        project_name='My FastAPI Service' \
        project_slug='{{project_slug}}' \
        package_name='{{package_name}}' \
        description='FastAPI + uv + structlog + JWT + SQLModel' \
        author_name='Your Name' \
        python_version='3.11' \
        use_postgres='{{use_postgres}}' \
        --output-dir '{{output_dir}}'
    just test-fastapi '{{output_dir}}' '{{project_slug}}'

# Convenience helper: render and smoke-test the Prefect template in one go.
check-prefect-flow output_dir='/tmp/cookiecutter_prefect_flow_check' project_slug='my_prefect_flow' package_name='my_prefect_flow':
    rm -rf '{{output_dir}}/{{project_slug}}'
    uvx cookiecutter "{{justfile_directory()}}/prefect_flow" --no-input \
        project_name='My Prefect Flow' \
        project_slug='{{project_slug}}' \
        package_name='{{package_name}}' \
        description='Prefect flow scaffold with Kubernetes-first deployment defaults' \
        author_name='Your Name' \
        python_version='3.12' \
        repository_url='https://github.com/your-org/your-repo.git' \
        default_branch='main' \
        deployment_name='default' \
        flow_module_name='example_flow' \
        flow_function_name='run_flow' \
        work_pool_name='kubernetes' \
        cron_schedule='0 2 * * *' \
        timezone='America/New_York' \
        --output-dir '{{output_dir}}'
    just test-prefect-flow '{{output_dir}}' '{{project_slug}}'

# Show the current git status for this repository.
status:
    git status --short
