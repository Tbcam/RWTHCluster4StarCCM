#!/bin/bash

ab123=$(whoami)
ZSHRC_PATH="/home/$ab123/.zshrc"
echo "                    
                          &&:                                                  
                        &&  &&                                                  
                     &&    &                                                    
                  .&;    &                                                      
                &$      &              :+&&&&&&&&+                                
            .X+          ;&:;++++++$&&&           .;X&&&&&&&x                     
                                                            .&&&&&&&X              
                           &            &        &&&                 x&&&&         
      &&&&  &&&& &  & &&& &$ &&x&  &&&& &$  &  &:    &                    &&&&     
     &__&$ &    x+  & &   & .&__&  __&& &   ;&&        &                    &&     
    ;;     &    &  & &    & &     &  & :&   & &         &                 $&       
     &&&:  &&&::&&&& &   && +&&&  &&:& && &&  &&          .+$&&&&&&&&&&&&&&        
    Starting Alias adder                                     MADE by TABO (last updated 04/07/2025) 
    further info:
   ecurieaix.qwikinow.de/content/3dbc5542-f955-4cda-a9ff-ec3618338842?title=qol-improvements-for-rwth-cluster-users"

# Download .zshrc template
curl -s https://raw.githubusercontent.com/Tbcam/RWTHCluster4StarCCM/main/.zshrc -o "$ZSHRC_PATH"

# Replace all occurrences of 'ab123' with your actual username
sed -i "s/ab123/$ab123/g" "$ZSHRC_PATH"

# Apply the changes immediately
source "$ZSHRC_PATH"

echo "Success!!!! 
.zshrc updated at this path $ZSHRC_PATH and applied for user: $ab123"
echo "You can try to use aliases now for example you can write helpalias, if that doesnt work close putty and open again."
