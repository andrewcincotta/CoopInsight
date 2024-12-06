########################################################
# Admin blueprint of endpoints
########################################################
import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)
import sys
from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

#------------------------------------------------------------
# Create a new Blueprint object
admin = Blueprint('admin', __name__)


#------------------------------------------------------------
# Get all jobratings info
@admin.route('/error_logs', methods=['GET'])
def get_error_logs():
    """
    Fetch error logs from the system.
    """
    query = "SELECT LogID, UserID, ErrorDescription, ErrorDate FROM ErrorLog ORDER BY ErrorDate DESC"
    cursor = db.get_db().cursor()
    cursor.execute(query)
    results = cursor.fetchall()
    return jsonify([dict(zip([col[0] for col in cursor.description], row)) for row in results]), 200
    