from tinydb import TinyDB, Query, where
from flask import jsonify

class Widget:

    def __init__(self):
        self.db = TinyDB('./app/db/data.json')


    def get_widgets(self):
        widgets = self.db.all()
        return jsonify(widgets)


    def get_widget(self, name):
        widget = self.db.search(where('name') == name)
        return jsonify(widget)


    def create_widget(self, data):
        self.db.insert(data)
        return self.get_widget(data['name'])


    def upsert_widget(self, name, data):
        Widget = Query()
        self.db.upsert(data, Widget.name == name)
        return self.get_widget(data['name'])


    def delete_widget(self, name):
        self.db.remove(where('name') == name)
        return 'Removed Widget with name %s' % name


    def purge(self):
        self.db.purge()
        return 'Purged database'
