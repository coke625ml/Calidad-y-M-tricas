import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

__all__ = ['get_spark_credentials', 'get_args_parser']

logger.info("leyendo paquetes")