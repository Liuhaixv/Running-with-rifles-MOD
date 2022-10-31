#include "log.as"
#include "helpers.as"
// #include "query_helpers.as"

class UpdateInventory {
    

    UpdateInventory() {

    }

    //TODO:
    string toString() {
        /*
            <command class="update_inventory" 
                    character_id="0"
                    container_type_class="stash"
                    add="1"
                    instance_class="carry_item"
                    instance_key="painting.carry_item">

            </command>

            <command class='update_inventory'
                    character_id='0'
                    container_type_class='backpack'>
                <item class='carry_item' key='painting.carry_item' />
            </command>
        */
        XmlElement c("command");
        c.setStringAttribute("class", "update_inventory");

        c.setIntAttribute("character_id", characterId); 
        c.setIntAttribute("container_type_id", 4);
        {
            XmlElement i("item");
            i.setStringAttribute("class", "carry_item");
            i.setStringAttribute("key", "vest_player.carry_item");
            c.appendChild(i);
        }
        return c.toString();
    }
}