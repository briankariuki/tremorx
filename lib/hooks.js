import LocalTime from "./js/date";
import ImageCache from "./js/image_cache";
import Input from "./js/input";
import Menu from "./js/menu";
import Tab from "./js/tab";
import Select from "./js/select";
import SearchSelect from "./js/search_select";
import MultiSelect from "./js/multi_select";
import Tooltip from "./js/tooltip";

let Hooks = {};

Hooks.LocalTime = LocalTime;
Hooks.Input = Input;
Hooks.ImageCache = ImageCache;
Hooks.Menu = Menu;
Hooks.Tab = Tab;
Hooks.Select = Select;
Hooks.SearchSelect = SearchSelect;
Hooks.MultiSelect = MultiSelect;
Hooks.Tooltip = Tooltip;

export default Hooks;
