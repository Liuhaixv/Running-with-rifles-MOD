weapons目录下定义了武器(.weapon) 和 投射物(.projectile)
其中，投射物可分为投掷物与非投掷物,投掷物(throwable)会单独注册在游戏中，作为手雷一类的武器
非投掷物即弹头类

因为基于原版vanilla使用，注册文件默认为stage_invasion.as中指定的文件名
{ XmlElement e("weapon");		e.setStringAttribute("file", "invasion_all_weapons.xml"); mapConfig.appendChild(e); }
{ XmlElement e("projectile");	e.setStringAttribute("file", "invasion_all_throwables.xml"); mapConfig.appendChild(e); }
{ XmlElement e("carry_item");	e.setStringAttribute("file", "invasion_all_carry_items.xml"); mapConfig.appendChild(e); }
{ XmlElement e("call");			e.setStringAttribute("file", "invasion_all_calls.xml"); mapConfig.appendChild(e); }
{ XmlElement e("vehicle");		e.setStringAttribute("file", "invasion_all_vehicles.xml"); mapConfig.appendChild(e); }
{ XmlElement e("achievement");	e.setStringAttribute("file", "achievements.xml"); mapConfig.appendChild(e); }