"""Authentication module for Neo Currículos + Neo RH System"""
import sys
import os

# Register modules with numeric prefixes
spec_path = os.path.join(os.path.dirname(__file__), '04_AUTH_UNIFICADA.py')

try:
    import importlib.util
    spec = importlib.util.spec_from_file_location('_auth_unificada', spec_path)
    if spec and spec.loader:
        module = importlib.util.module_from_spec(spec)
        # Register under both names
        sys.modules['auth.04_AUTH_UNIFICADA'] = module
        sys.modules['auth._auth_unificada'] = module
        spec.loader.exec_module(module)

        # Also export for local imports
        from auth._auth_unificada import *  # noqa
except Exception as e:
    print(f"Warning: Could not load auth: {e}")
