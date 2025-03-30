#!/usr/bin/env python3

import pymoos
import time

class MoosClient(pymoos.comms):

    def __init__(self, address, port):

        super(MoosClient, self).__init__()
        self.server = address
        self.port = port
        self.name = 'iAPI'

        self.set_on_connect_callback(self.__on_connect)
        self.run(self.server, self.port, self.name)

    def __on_connect(self):

        print("Registered as {0} to {1}:{2}".format(self.name,
                                                     self.server,
                                                     self.port))

        return True

