define(['mediator'], function (mediator) {
  'use strict';
  
  describe('mediator', function () {

    it('should be a simple object', function () {
      expect(typeof mediator).toEqual('object');
    });

    it('should have a router which is null', function () {
      expect(mediator.router).toBeNull();
    });

    it('should have a user which is null', function () {
      expect(mediator.user).toBeNull();
    });

    it('should have Pub/Sub methods', function () {
      expect(typeof mediator.subscribe).toEqual('function');
      expect(typeof mediator.unsubscribe).toEqual('function');
      expect(typeof mediator.publish).toEqual('function');
    });

    it('should have non-writable Pub/Sub methods', function () {
      if (!Object.getOwnPropertyDescriptor) return;
      ['subscribe', 'unsubscribe', 'publish'].forEach(function (property) {
        var desc = Object.getOwnPropertyDescriptor(mediator, property);
        console.debug(property, desc, desc.writable);
        expect(desc.writable).toBe(false);
      });
    });

    it('should be sealed', function () {
      if (Object.isSealed) {
        expect(Object.isSealed(mediator)).toBe(true);
      }
    });

    it('should publish messages to subscribers', function () {
      var callback = jasmine.createSpy();
      var eventName = 'foo', payload = 'payload';
      mediator.subscribe(eventName, callback);
      mediator.publish(eventName, payload);
      expect(callback).toHaveBeenCalledWith(payload);
    });

    it('should allow to unsubscribe to events', function () {
      var callback = jasmine.createSpy();
      var eventName = 'foo', payload = 'payload';
      mediator.subscribe(eventName, callback);
      mediator.unsubscribe(eventName, callback);
      mediator.publish(eventName, payload);
      expect(callback).not.toHaveBeenCalledWith(payload);
    });

  });
});