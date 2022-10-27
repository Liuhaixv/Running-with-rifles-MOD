#include "log.as"
#include "query_helpers.as"


// --------------------------------------------
class Character {
    const XmlElement@ data;

	Character(Metagame@ m_metagame, int character_id) {
        @data = getCharacterInfo(m_metagame, character_id);
    }
}

