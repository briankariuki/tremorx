import LocalTime from "./js/date";
import ImageCache from "./js/image_cache";
import Input from "./js/input";
import Menu from "./js/menu";
import Tab from "./js/tab";
import Select from "./js/select";

let Hooks = {};

Hooks.LocalTime = LocalTime;
Hooks.Input = Input;
Hooks.ImageCache = ImageCache;
Hooks.Menu = Menu;
Hooks.Tab = Tab;
Hooks.Select = Select;

export default Hooks;
