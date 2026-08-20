/************************************************************/
/*    NAME: Mathew Schwartzman                                              */
/*    ORGN: MIT, Cambridge MA                               */
/*    FILE: MOOSClient.h                                          */
/*    DATE: December 29th, 1963                             */
/************************************************************/

#ifndef MOOSClient_HEADER
#define MOOSClient_HEADER

#include "MOOS/libMOOS/Thirdparty/AppCasting/AppCastingMOOSApp.h"

class MOOSClient : public AppCastingMOOSApp
{
 public:
   MOOSClient();
   ~MOOSClient();

 protected: // Standard MOOSApp functions to overload  
   bool OnNewMail(MOOSMSG_LIST &NewMail);
   bool Iterate();
   bool OnConnectToServer();
   bool OnStartUp();

 protected: // Standard AppCastingMOOSApp function to overload 
   bool buildReport();

 protected:
   void registerVariables();

 private: // Configuration variables

 private: // State variables
};

#endif 
