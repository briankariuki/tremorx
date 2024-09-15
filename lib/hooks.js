import LocalTime from "./js/date";
import ImageCache from "./js/image_cache";
import Input from "./js/input";
import Menu from "./js/menu";
import Tab from "./js/tab";
import Select from "./js/select";
import SearchSelect from "./js/search_select";
import MultiSelect from "./js/multi_select";
import Tooltip from "./js/tooltip";
import AreaChart from "./js/area_chart";
import LineChart from "./js/line_chart";
import BarChart from "./js/bar_chart";
import DonutChart from "./js/donut_chart";

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
Hooks.AreaChart = AreaChart;
Hooks.LineChart = LineChart;
Hooks.BarChart = BarChart;
Hooks.DonutChart = DonutChart;

export default Hooks;
