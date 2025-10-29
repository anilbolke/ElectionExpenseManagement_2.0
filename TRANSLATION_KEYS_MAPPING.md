# Translation Keys Mapping for All Pages
# This file maps all hardcoded English text to translation keys

## Admin Navigation
"Admin Portal" => "admin.dashboard"
"Dashboard" => "app.dashboard"
"Users" => "admin.users"
"Candidates" => "admin.candidates"
"Brokers" => "admin.brokers"
"Logout" => "app.logout"

## Page Headings
"All Users" => "heading.view.all.users"
"All Candidates" => "heading.view.all.candidates"
"All Brokers" => "heading.view.all.brokers"
"Add New Candidate" => "heading.add.new.candidate"
"Edit Candidate" => "heading.edit.candidate"
"Add Expense" => "heading.add.expense"
"View Expenses" => "heading.view.expenses"
"Edit Expense" => "heading.edit.expense"
"User Profile" => "heading.user.profile"
"Complete Profile" => "heading.complete.profile"
"Subscription Plans" => "heading.subscription.plans"
"Payment Gateway" => "heading.payment.gateway"
"Payment Successful" => "heading.payment.success"

## Table Headers
"ID" => "table.id"
"Username" => "login.username"
"Full Name" => "user.fullname"
"Email" => "table.email"
"Phone" => "table.phone"
"Mobile" => "candidate.mobile"
"Role" => "user.role"
"Status" => "table.status"
"Created" => "user.joined.date"
"Actions" => "table.actions"
"S.No." => "table.sno"
"Name" => "table.name"
"Date" => "table.date"
"Amount" => "table.amount"

## Stats & Cards
"Total Users" => "card.total.users"
"Total Candidates" => "card.total.candidates"
"Active Candidates" => "card.active.candidates"
"Total Expenses" => "card.total.expenses"
"Pending Payments" => "card.pending.payments"
"Admins" => "admin.role.admin"
"Regular Users" => "admin.role.user"
"Brokers" => "admin.role.broker"

## Buttons
"Add New" => "button.add.new"
"Submit" => "button.submit"
"Update" => "button.update"
"Cancel" => "button.cancel"
"Save Changes" => "button.save.changes"
"Edit" => "button.edit"
"Delete" => "button.delete"
"View Details" => "button.view.details"
"Back" => "button.back"
"Pay Now" => "button.pay.now"
"Choose File" => "button.choose.file"
"Upload" => "button.upload"

## Form Labels  
"Candidate Name" => "candidate.name"
"Age" => "candidate.age"
"Gender" => "candidate.gender"
"Email Address" => "register.email"
"Mobile Number" => "candidate.mobile"
"Aadhar Number" => "candidate.aadhar"
"Voter ID" => "candidate.voterid"
"Constituency" => "candidate.constituency"
"Party Name" => "candidate.party"
"Election Type" => "candidate.election.type"
"Password" => "login.password"
"Confirm Password" => "register.confirm.password"
"Phone Number" => "register.phone"
"Address" => "form.address"
"City" => "form.city"
"State" => "form.state"
"Pincode" => "form.pincode"

## Expense Fields
"Expense Date" => "expense.date"
"Category" => "expense.category"
"Description" => "expense.description"
"Receipt" => "expense.receipt"

## Status Labels
"Active" => "status.active"
"Inactive" => "status.inactive"
"Pending" => "status.pending"
"Verified" => "status.verified"
"Paid" => "status.paid"
"Unpaid" => "status.unpaid"

## Gender Options
"Male" => "gender.male"
"Female" => "gender.female"
"Other" => "gender.other"
"Select Gender" => "gender.select"

## Election Types
"Lok Sabha" => "election.type.lok.sabha"
"Vidhan Sabha" => "election.type.vidhan.sabha"
"Municipal" => "election.type.municipal"
"Panchayat" => "election.type.panchayat"

## Messages
"No data available" => "message.no.data"
"Loading..." => "message.loading"
"Operation completed successfully" => "message.success"
"An error occurred" => "message.error"
"No users found" => "empty.no.users"
"No candidates found" => "empty.no.candidates"
"No brokers found" => "empty.no.brokers"
"No expenses found" => "empty.no.expenses"

## Search & Filter
"Search..." => "search.placeholder"
"Filter by Status" => "filter.by.status"
"All" => "filter.all"
"Showing" => "text.showing"
"entries" => "text.entries"

## Broker Fields
"Broker Name" => "broker.name"
"Business Name" => "broker.business"
"License Number" => "broker.license"
"GST Number" => "broker.gst.number"
"PAN Number" => "broker.pan.number"

## Payment Fields
"Transaction ID" => "payment.transaction.id"
"Order ID" => "payment.order.id"
"Payment Method" => "payment.method"
"Payment Status" => "payment.status"
"Payment Date" => "payment.date"

## Menu Items
"View Users" => "menu.view.users"
"View Candidates" => "menu.view.candidates"
"View Brokers" => "menu.view.brokers"
"Register Broker" => "menu.register.broker"
"User Details" => "menu.user.details"
"Candidate Details" => "menu.candidate.details"
"Broker Details" => "menu.broker.details"
"Add Candidate" => "menu.add.candidate"
"Manage Candidates" => "menu.manage.candidates"
"Edit Candidate" => "menu.edit.candidate"
"Add Expense" => "menu.add.expense"
"Expenses" => "menu.expenses"
"Edit Expense" => "menu.edit.expense"
"Complete Profile" => "menu.complete.profile"
"My Users" => "menu.my.users"
"My Candidates" => "menu.my.candidates"
"Candidates" => "menu.candidates"
"Transactions" => "menu.transactions"
"Subscription" => "menu.subscription"

## Pagination
"First" => "pagination.first"
"Last" => "pagination.last"
"Next" => "pagination.next"
"Previous" => "pagination.previous"
"Page" => "text.page"
"of" => "text.of"

## Quick Actions
"Quick Actions" => "dashboard.quick.actions"
"Add your first candidate to get started" => "candidate.addnew"

## Confirmation Messages
"Are you sure you want to delete this user?" => "confirm.delete.user"
"Are you sure you want to delete this candidate?" => "confirm.delete.candidate"
"Are you sure you want to delete this broker?" => "confirm.delete.broker"
"Are you sure you want to delete this expense?" => "confirm.delete.expense"
"Are you sure you want to logout?" => "confirm.logout"

## Profile Fields
"Personal Information" => "profile.personal.info"
"Contact Information" => "profile.contact.info"
"Address Information" => "profile.address.info"
"Update Profile" => "profile.update"

## Error Page
"Error Occurred" => "error.page.title"
"Oops! Something went wrong" => "error.page.heading"
"Go to Home" => "error.page.home"
"Go Back" => "error.page.back"

## Breadcrumbs (combine with /)
"Dashboard / Users" => <%= MessageBundle.getMessage(request, "app.dashboard") %> / <%= MessageBundle.getMessage(request, "admin.users") %>
"Dashboard / Candidates" => <%= MessageBundle.getMessage(request, "app.dashboard") %> / <%= MessageBundle.getMessage(request, "admin.candidates") %>
"Dashboard / Brokers" => <%= MessageBundle.getMessage(request, "app.dashboard") %> / <%= MessageBundle.getMessage(request, "admin.brokers") %>
