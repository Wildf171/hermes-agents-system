"""Database models for Neo Currículos + Neo RH System"""
import sys
import os

# Register modules with numeric prefixes
# This allows "from models.06_MODELS_MONGODB import ..." to work
spec_path = os.path.join(os.path.dirname(__file__), '06_MODELS_MONGODB.py')

try:
    import importlib.util
    spec = importlib.util.spec_from_file_location('_models_mongodb', spec_path)
    if spec and spec.loader:
        module = importlib.util.module_from_spec(spec)
        # Register under both names
        sys.modules['models.06_MODELS_MONGODB'] = module
        sys.modules['models._models_mongodb'] = module
        spec.loader.exec_module(module)

        # Also export for local imports
        from models._models_mongodb import *  # noqa
except Exception as e:
    print(f"Warning: Could not load models: {e}")
