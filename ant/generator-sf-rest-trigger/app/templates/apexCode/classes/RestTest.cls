@isTest
public class <%= name %>Test {
    static testMethod void testCreate<%= name %><%= entity %>() {
        // don't save!  Or we won't be able to run the callout
        // (there will be an error about uncommitted work pending)
        <%= entity %> opp = <%= testFactory %>(false);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CreateCalloutMock());
        <%= name %> api = new <%= name %>Impl();
        String resultId = api.create<%= name %><%= entity %>(opp);
        Test.stopTest();

        System.assertEquals('5733008e487d901208a0a22e', resultId);
    }

    static testMethod void testUpdate<%= name %><%= entity %>() {
        // don't save!  Or we won't be able to run the callout
        <%= entity %> opp = <%= testFactory %>(false);
        <% if(externalPropertyId) { %>
        opp.<%= externalPropertyId %> = '5733008e487d901208a0a22e';
        <% } %>

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new UpdateCalloutMock());
        <%= name %> api = new <%= name %>Impl();
        api.update<%= name %><%= entity %>(opp);
        Test.stopTest();
    }

    static testMethod void testThrows<%= name %>Exception() {
        <%= entity %> opp = <%= testFactory %>(false);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ErrorCalloutMock());
        try {
            <%= name %> api = new <%= name %>Impl();
        	api.create<%= name %><%= entity %>(opp);
        } catch(<%= name %>Exception x) {
        	Test.stopTest();
            return;
        }
        System.assert(false, 'Should have thrown exception');
    }

    // TODO implement callout mocks ...  Some examples below
    public class CreateCalloutMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            // create project
            if(req.getMethod() == 'POST' && req.getEndpoint().endsWith('/project')) {
                res.setBody('{"_id": "5733008e487d901208a0a22e",  "name": "project9"}');
                res.setStatusCode(201);
            // create booking
            } else if(req.getMethod() == 'POST' && req.getEndpoint().endsWith('/booking')) {
                res.setBody('{"_id": "574856601338136c7aa67912"}');
                res.setStatusCode(201);
            } else {
                res.setStatusCode(400);
            }
            return res;
        }
    }

    public class UpdateCalloutMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            // update project
            if(req.getMethod() == 'PUT' && req.getEndpoint().endsWith('/project/5733008e487d901208a0a22e')) {
                res.setBody('{"_id": "5733008e487d901208a0a22e",  "name": "project9"}');
                res.setStatusCode(200);
            // locate booking
            } else if(req.getMethod() == 'POST' && req.getEndpoint().endsWith('/booking/search')) {
                res.setBody('[{"_id": "573f3e5c53c20685197aced2"}]');
                res.setStatusCode(200);
            // update booking
            } else if(req.getMethod() == 'PUT' && req.getEndpoint().endsWith('/booking/573f3e5c53c20685197aced2')) {
                res.setStatusCode(200);
            } else {
                res.setStatusCode(400);
            }
            return res;
        }
    }

    public class ErrorCalloutMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(400);
            return res;
        }
    }
}
