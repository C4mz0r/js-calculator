function add(x, y) {
	return x + y;	
}

function multiply(x, y) {
	return x * y;
}

function divide(x, y) {
	return 1.0 * x / y;
}

function subtract(x, y) {
	return x - y;
}

function updateDisplay(buffer) {
	$('.screen').text(buffer);
}

var allowableNumbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
var allowableOperators = ['+', '-', '*', '/', '='];

$(document).ready( function(){

	// help us know if we are dealing with the left operand,
	// the operator, or the right operand.
	const left = 1, op = 2, right = 3;
	const clear = "Clear";

	// Hold the key presses	
	var buffer = [];
	var currentNumberBuffer = [];
	var justEvaluated = false;	
	var currentState = left;
	
	var leftHandSide = "";
	var operator = "";
	var rightHandSide = "";
	var shouldClearLeftHandSide = false;
		
	// "Listen" to the keys that are pressed and store in the buffer.
	// When the equal button is pressed, then the buffer gets evaluated.
	
	$("div").click(function(){				
	
		var pressed = $(this).context.textContent;
		console.log("Detected: " + pressed);
		if (currentState === left) {
			
			// is the pressed key a number?
			// if so, then 'grow' the current number
			if ( allowableNumbers.indexOf(pressed) >= 0 ) {				
				if (shouldClearLeftHandSide === true) {
					leftHandSide = "";
					shouldClearLeftHandSide = false;
				}				
				leftHandSide += pressed;
				updateDisplay(leftHandSide);				
			} else if (allowableOperators.indexOf(pressed) >= 0) {
				operator = pressed;
				currentState = op;
			} else if (pressed === clear) {
				currentState = left;
				leftHandSide = [];
				rightHandSide = [];
				operator = "";
				updateDisplay(leftHandSide);
			}
			
			 
		}
	    
	    else if ( currentState === op || currentState === right ) {
			if ( allowableNumbers.indexOf(pressed) >= 0 ) {
				rightHandSide += pressed;
				updateDisplay(rightHandSide);
			} else if (allowableOperators.indexOf(pressed) >= 0) {
				// evaluate LHS ("old" operator) RHS and store in LHS,
				// then clear out RHS.
				
				x = parseFloat(leftHandSide);
				y = parseFloat(rightHandSide);
				
				// Calculate if the operands are not NaN:
				if ( !isNaN(x) && !isNaN(y) )
				{
					
					switch(operator) {					
						case '+': 
							leftHandSide = add(x, y).toString();
							rightHandSide = "";								
							break;
						
						case '-':
							leftHandSide = subtract(x, y).toString();
							rightHandSide = "";
							break;
						
						case '*':
							leftHandSide = multiply(x, y).toString();
							rightHandSide = "";
							break;
						
						case '/': 
							leftHandSide = divide(x, y).toString();
							rightHandSide = "";
							break;
					}
				
					updateDisplay(leftHandSide);
				
				}
				
				if (pressed === '=') {
					// after the user presses equals, then the next input
					// would be the LHS operator, and it should be flagged to clear out
					// when the user starts typing it next time.
					// We don't clear it directly now, since we want to allow the user to possibly type another
					// operator, such as '+' and then the next RHS number.
					currentState = left;
					operator = "";
					shouldClearLeftHandSide = true;
				}
				else {				
					currentState = op;				
					operator = pressed;
				}
				
				
			} else if (pressed === clear) {
				currentState = left;
				leftHandSide = [];
				rightHandSide = [];
				operator = "";
				updateDisplay(leftHandSide);
			}
		}
		
			
		console.log("LHS is now: " + leftHandSide.toString());
		console.log("Operator is now: " + operator);
		console.log("RHS is now: " + rightHandSide.toString());
	});
	
		
});	    
		