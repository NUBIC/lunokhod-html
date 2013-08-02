(function () {
  window.Lunokhod = Ember.Application.create();

  // A container contains sections and questions.
  window.Lunokhod.Container = Ember.Mixin.create({
    addSection: function(section) {
      this.get('sections').pushObject(section);
    },

    addQuestion: function(question) {
      this.get('questions').pushObject(question);
    }
  });

  window.Lunokhod.Survey = Ember.Object.extend(Lunokhod.Container, {
  });

  window.Lunokhod.Section = Ember.Object.extend(Lunokhod.Container, {
  });

  window.Lunokhod.Group = Ember.Object.extend(Lunokhod.Container, {
  });

  window.Lunokhod.Repeater = Ember.Object.extend(Lunokhod.Container, {
  });

  window.Lunokhod.Grid = Ember.Object.extend({
    // A grid has questions, but it isn't a Container.
    addQuestion: function(question) {
      this.get('questions').pushObject(question);
    }
  });

  window.Lunokhod.Question = Ember.Object.extend({
  });

  Lunokhod.ApplicationController = Ember.ObjectController.extend({
    contentBinding: 'Lunokhod.survey'
  });
})();

// vim:ts=2:sw=2:et:tw=78:ft=javascript
