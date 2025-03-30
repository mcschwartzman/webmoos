#!/usr/bin/env python3

import pymoos
import time
import json

import paho.mqtt.publish as publish

class MoosClient(pymoos.comms):

    def __init__(self, address, port):

        super(MoosClient, self).__init__()
        self.server = address
        self.port = port
        self.name = 'iAPI'

        self.set_on_connect_callback(self.__on_connect)
        self.set_on_mail_callback(self.__on_new_mail)
        self.run(self.server, self.port, self.name)

    def __on_connect(self):

        print("Registered as {0} to {1}:{2}".format(self.name,
                                                     self.server,
                                                     self.port))

        self.register('NODE_REPORT', 0)

        return True

    def __on_new_mail(self):
        for msg in self.fetch():
            if msg.key() == 'NODE_REPORT':

                data_string = msg.string()
                split_string = data_string.split(',')
                json_dict = {}
                for pair in split_string:

                    key = pair.split('=')[0]
                    value = pair.split('=')[1]
                    json_dict[key] = value

            jsonified = json.dumps(json_dict)
            self.notify('NODE_REPORT_JSON', jsonified, -1)

            publish.single("node-report", jsonified, hostname="10.1.0.4")
            

        return True