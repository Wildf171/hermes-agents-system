"""Routes for Neo Currículos + Neo RH System"""
import sys
import os

# Register modules with numeric prefixes
spec_path = os.path.join(os.path.dirname(__file__), '05_ROUTES_NEO_CURRICULOS.py')

try:
    import importlib.util
    spec = importlib.util.spec_from_file_location('_routes_neo_curriculos', spec_path)
    if spec and spec.loader:
        module = importlib.util.module_from_spec(spec)
        # Register under both names
        sys.modules['routes.05_ROUTES_NEO_CURRICULOS'] = module
        sys.modules['routes._routes_neo_curriculos'] = module
        spec.loader.exec_module(module)

        # Also export for local imports
        from routes._routes_neo_curriculos import *  # noqa
except Exception as e:
    print(f"Warning: Could not load routes: {e}")
