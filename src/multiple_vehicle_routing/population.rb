# frozen_string_literal: true

module MultipleVehicleRouting
  class Population
    attr_reader :places, :permitted_load, :size, :max_generation_runs, :current_generation_run, :mutation_probability, :routes

    def initialize(options)
      @places                 = options[:places]
      @permitted_load         = options[:permitted_load]
      @size                   = options[:size]                 || Integer((places.size * 1.5))
      @max_generation_runs    = options[:max_generation_runs]  || 5000
      @current_generation_run = 0
      @mutation_probability   = options[:mutation_probability] || 0.10
    end

    def create_routes
      @routes = (1..size).map { |_route| Route.new(places: places, permitted_load: permitted_load) }
    end

    def run
      create_routes
      tick until terminate?
      routes.each { |route| puts(route) }
    end

    def tick
      @current_generation_run += 1
      routes.each { |route| route.mutate! if mutate? }
      puts("Generation: #{@current_generation_run}")
    end

    def mutate?
      rand < mutation_probability
    end
    private :mutate?

    def terminate?
      current_generation_run >= max_generation_runs
    end
  end
end
