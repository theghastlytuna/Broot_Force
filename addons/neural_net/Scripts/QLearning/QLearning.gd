class_name QLearning

# Observation Spaces are the possible states the agent can be in
# Action Spaces are the possible actions the agent can take
var observation_space: int
var action_spaces: int

# The table that contains the value for each cell in the QLearning alogorithm
var QTable: Matrix

# Hyper-parameters
var exploration_probability: float = 1.0 # The probability that the agent will either explore or exploit the QTable
var exploration_decreasing_decay: float = 0.01 # The exploartion decreasing decay for exponential decreasing
var min_exploration_probability: float = 0.01 # The least value that the exploration_probability can fall to
var discounted_factor: float = 0.9 # Basically the gamma
var learning_rate: float = 0.2 # How fast the agent learns
var decay_per_steps: int = 100
var steps_completed: int = 0

# States
var previous_state: int = -100# To be used in the algorithms
var current_state: int # To be swapped for the previous state at the end of each prediction
var previous_action: int # To b usd in the algorithm

var done: bool = false
var is_learning: bool = true
var print_debug_info: bool = false

func _init(n_observations: int, n_action_spaces: int, _is_learning: bool = true) -> void:
	observation_space = n_observations
	action_spaces = n_action_spaces
	is_learning = _is_learning
	
	QTable = Matrix.new(observation_space, action_spaces)

func predict(current_state: int, reward_of_previous_state: float) -> int:
	if is_learning:
		if previous_state != -100:
			QTable.data[previous_state][previous_action] = (1 - learning_rate) * QTable.data[previous_state][previous_action] + \
			learning_rate * (reward_of_previous_state + discounted_factor * QTable.max_from_row(current_state))
		
	var action_to_take: int
	
	# If randf is lesser than the exploration probability, which will be the case initially, 
	# it chooses a random value, else, it exploits the QTable
	if randf() < exploration_probability and is_learning:
		action_to_take = randi_range(0, action_spaces - 1)
	else:
		action_to_take = QTable.index_of_max_from_row(current_state)
	
	if is_learning:
		previous_state = current_state
		previous_action = action_to_take
	
		if steps_completed != 0 and steps_completed % decay_per_steps == 0:
			exploration_probability = maxf(min_exploration_probability, exploration_probability - exploration_decreasing_decay)#, exp(-exploration_decreasing_decay * exp(1)))
	
	if print_debug_info and steps_completed % decay_per_steps == 0:
		print("Total steps completed:", steps_completed)
		print("Current exploration probability:", exploration_probability)
		print("Q-Table data:", QTable.data)
		print("-----------------------------------------------------------------------------------------")
	
	steps_completed += 1
	return action_to_take
