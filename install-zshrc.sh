#!/bin/bash

ab123=$(whoami)
ZSHRC_PATH="/home/$ab123/.zshrc"
echo "                                                                                                                  
                                                                                                                  
                                                                                                                  
                                      &&&x                                                                        
                                   X&&   &&                                                                       
                                ;&&;   &&                                                                         
                              &&;    &&:                                                                          
                           &&+     .&&                                                                            
                        &&$      :&&                                                                              
                    .&&:           &&                  &.  .:+x$&&&&&&&&&&:                                       
                  XX                :&&+++++++x+xX&&&&&                   :x&&&&&&&x                              
                                                                                    x&&&&&$                       
                                   :&&                 &&                                  +&&&&$                 
                                                                  $&&&                           &&&&&            
        &&&&&X  &&&&& &&:  && &&&& &&  &&&&&  .&&&&&+  &  &&  +&&      &&                             &&&&&       
       &:   ;& &X   X &;   &  &    &; &    &x      &. &&   &&x&          &&                              :&       
       &&&&&&  &      &.  && &&   X& X&&&&&&  &&&&&&  &     &&             &                           +&&        
      $&      &&   X &$   &  &    && &       &&   &  &&   && &&            .&                         &&          
      x&&x&&  &&:&&& &&$&&& .&   $&  &&&X&&  &&&&&&$ && &&   &&&            X   .::;;;++xxxxxXXXXX$x&&&           
                                                    MADE by TABO                                                
                                                                                                                  
                                                                                                                  "

# Download .zshrc template
curl -s https://raw.githubusercontent.com/Tbcam/RWTHCluster4StarCCM/main/.zshrc -o "$ZSHRC_PATH"

# Replace all occurrences of 'ab123' with your actual username
sed -i "s/ab123/$ab123/g" "$ZSHRC_PATH"

# Apply the changes immediately
source "$ZSHRC_PATH"

echo "Success .zshrc updated at this path $ZSHRC_PATH and applied for user: $ab123"
