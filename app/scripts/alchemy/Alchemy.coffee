"""
Alchemy.js is a graph drawing application for the web.
Copyright (C) 2014  GraphAlchemist, Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
lets
"""

class Alchemy
    constructor: () ->
        # Alchemy houses a number modules that can be considered submodules
        @version = "#VERSION#"
        @layout = {}
        @interactions = {}
        @utils = {}
        @visControls = {}
        @styles = {}
        @models = {}
        @drawing = {}
        @editor = {}
        @log = {}
        @state =
            "interactions": "default"
            "layout": "default"
            "filters":
                "edges": {}
                "nodes": {}
        
        # node and edge internals...  It is unadvised to access internals
        # directly.  Use, alchemy.get.nodes or alchemy.get.edges
        @_nodes = {}

        # alchemy._edges stores an array of edges under every unique id.
        # the edge model is a key value pair where the "key" is either
        # 1) an id provided in the GraphJSON data, or 2) an id generated by
        # Alchemy taking the format of "#{source}-#{target}".  
        # The value is an array of edge 'packets', where the length of the array
        # is typically 1.
        @_edges = {}

        # extend alchemy with API methods
        # _.extend @, api()

    allEdges: -> _.map @_edges, (e) -> e.properties
    allNodes: -> _.map @_nodes, (n) -> n.properties

    getState: (key) => if @state.key? then @state.key
    setState: (key, value) => @state.key = value

    begin: (userConf) =>
        # overide configuration with user inputs
        @conf = _.assign {}, alchemy.defaults, userConf
        if typeof alchemy.conf.dataSource is 'string'
            d3.json alchemy.conf.dataSource, alchemy.startGraph
        else if typeof alchemy.conf.dataSource is 'object'
            alchemy.startGraph alchemy.conf.dataSource

    #API methods
    getNodes: (id, ids...) =>
        # returns one or more nodes as an array
        if ids
            ids.push id
            params = _.union ids
            results = []
            for p in params
                results.push alchemy._nodes[p].properties
            results
        else
            [@_nodes[id].properties]

    getEdges: (id=null, target=null) =>
        # returns one or more edges as an array
        if id? and target?
            edge_id = "#{id}-#{target}"
            edge = @_edges[edge_id]
            [edge.properties]
        else if id? and not target?
            results = _.map @_edges, (edge) -> 
                        if (edge.properties.source is id) or (edge.properties.target is id)
                            edge.properties
            _.compact results

    allNodes: => _.map @_nodes, (n) -> n.properties
    allEdges: => _.map @_edges, (e) -> e.properties

currentRelationshipTypes = {}

if typeof module isnt 'undefined' and module.exports
  module.exports = new Alchemy()
else
  @alchemy = new Alchemy()
