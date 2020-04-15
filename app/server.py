from flask import Flask, jsonify, request
from .widgets import Widget

API_VERSION_NUMBER = '1.0'
API_VERSION_LABEL = 'v1'

class FlaskApp(object):

    def __init__(self):
        self.app = Flask(__name__)
        widget = Widget()

        @self.app.route('/health-check', methods=['GET'])
        def healthCheck():
            return 'OK'

        @self.app.route('/v1/widgets', methods=['GET', 'POST'])
        def widgetsFunction():
            if request.method == 'GET':
                return widget.get_widgets()
            elif request.method == 'POST':
                return widget.create_widget(request.get_json())

        @self.app.route('/v1/widgets/<string:name>', methods=['GET', 'PUT', 'DELETE'])
        def widgetFunctionName(name):
            if request.method == 'GET':
                return widget.get_widget(name)

            elif request.method == 'PUT':
                return widget.upsert_widget(name, request.get_json())

            elif request.method == 'DELETE':
                return widget.delete_widget(name)

        @self.app.route('/v1/widgets/purge', methods=['POST'])
        def widgetPurge():
            return widget.purge()


    def run(self, *args, **kwargs):
        self.app.config['PROPAGATE_EXCEPTIONS'] = False
        self.app.run(port=8080, *args, **kwargs)


def run_app(*args, **kwargs):
    app = FlaskApp()
    app.run(*args, **kwargs)


if __name__ == '__main__':
    run_app(debug=True)
