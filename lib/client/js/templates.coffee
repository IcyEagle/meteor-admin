Template.AdminDashboardViewWrapper.rendered = ->
	node = @firstNode

	@autorun ->
		data = Template.currentData()

		if data.view then Blaze.remove data.view
		while node.firstChild
			node.removeChild node.firstChild

		data.view = Blaze.renderWithData Template.AdminDashboardView, data, node

Template.AdminDashboardViewWrapper.destroyed = ->
	Blaze.remove @data.view

Template.AdminDashboardView.rendered = ->
	table = @$('.dataTable').DataTable();
	filter = @$('.dataTables_filter')
	length = @$('.dataTables_length')

	query = ''
	showOnlyCompleted = false

	filter.html '
		<div class="btn-toolbar" role="toolbar">
			<div class="input-group">
				<input type="search" class="form-control input-sm" placeholder="Search"></input>
				<div class="input-group-btn">
					<button class="btn btn-sm btn-default">
						<i class="fa fa-search"></i>
					</button>
				</div>
			</div>
			<div class="btn-group" role="group">
				<button type="button" class="btn btn-primary show-completed" data-toggle="button" aria-pressed="false" autocomplete="off">
					Show only completed
				</button>
			</div>
		</div>
	'

	length.html '
		<div class="input-group">
			<select class="form-control input-sm">
				<option value="10">10</option>
				<option value="25">25</option>
				<option value="50">50</option>
				<option value="100">100</option>
			</select>
		</div>
	'

	onQueryChanged = ->
		request = table.columns([0, 1]).search(query)
		request = if showOnlyCompleted then request.column(4).search('true', false) else request.column(4).search('')
		request.draw()
		#		if showOnlyCompleted then table.column(4).search('true', false, true) else table.column(4).search('', false, true)
#		table.draw()

	filter.find('input').on 'keyup', ->
		query = @value
		onQueryChanged()

	filter.find('.show-completed').on 'click', ->
		showOnlyCompleted = !showOnlyCompleted
		onQueryChanged()

	length.find('select').on 'change', ->
		table.page.len(parseInt @value).draw()

Template.AdminDashboardView.helpers
	hasDocuments: ->
		AdminCollectionsCount.findOne({collection: Session.get 'admin_collection_name'})?.count > 0
	newPath: ->
		Router.path 'adminDashboard' + Session.get('admin_collection_name') + 'New'

Template.adminEditBtn.helpers
	path: ->
		Router.path "adminDashboard" + Session.get('admin_collection_name') + "Edit", _id: @_id
