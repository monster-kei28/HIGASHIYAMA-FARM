import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import CalendarBulkController from "./calendar_bulk_controller"
application.register("calendar-bulk", CalendarBulkController)

