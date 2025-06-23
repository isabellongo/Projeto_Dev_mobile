# Deploy with `firebase deploy`
import base64

from firebase_admin import initialize_app
from firebase_functions import https_fn
from firebase_functions.options import set_global_options
from flask import jsonify, Request

# For cost control, you can set the maximum number of containers that can be
# running at the same time. This helps mitigate the impact of unexpected
# traffic spikes by instead downgrading performance. This limit is a per-function
# limit. You can override the limit for each function using the max_instances
# parameter in the decorator, e.g. @https_fn.on_request(max_instances=5).
set_global_options(max_instances=10)

app = initialize_app()


@https_fn.on_request()
def ocr_handler(req: Request):
    if req.method != "POST":
        return jsonify({"error": "Method not allowed"}), 405

    if req.content_type.startswith("multipart/form-data"):
        if 'image' not in req.files:
            return jsonify({"error": "No image part"}), 400
        image_file = req.files['image']
        # Extract image from the data stream
        # image =

    elif req.is_json:
        data = req.get_json()
        if 'image_base64' not in data:
            return jsonify({"error": "Missing base64 image"}), 400
        try:
            image_data = base64.b64decode(data['image_base64'])
            # Extract image from the data
            # image =
        except Exception as e:
            return jsonify({"error": f"Invalid image data: {str(e)}"}), 400
    else:
        return jsonify({"error": "Unsupported Content-Type"}), 415

    try:
        text = "Example"
        return jsonify({"text": text})
    except Exception as e:
        return jsonify({"error": "OCR failed", "details": str(e)}), 500
