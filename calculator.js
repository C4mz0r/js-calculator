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

function evaluate(buffer) {
	console.log("In evaluate, with buffer: " + buffer);
	var stringBuffer = buffer.toString().replace(/,/g,'');
	console.log("String buffer is " + stringBuffer);
	//console.log(eval(stringBuffer));
	return eval(stringBuffer);
}

function updateExpression(buffer) {
	$('.expression').text(buffer);
}

function updateDisplay(buffer) {
	$('.screen').text(buffer);
}

$(document).ready( function(){

	// Hold the key presses	
	var buffer = [];
	var screenDisplay = [];
	var justEvaluated = false;	
		
	// "Listen" to the keys that are pressed and store in the buffer.
	// When the equal button is pressed, then the buffer gets evaluated.
	
	$("div").click(function(){				
	
		var pressed = $(this).context.textContent;
		switch( pressed )
		{
			case "1":
			case "2":
			case "3":
			case "4":
			case "5":
			case "6":
			case "7":
			case "8":
			case "9":
			case "0":
			   			
			   	// If the previous answer is showing,
			   	// typing a new number should start things
			   	// over fresh.
				if (justEvaluated === true) {
				  buffer = [pressed];
				  justEvaluated = false;
				  break;
				}
								
			case "+":
			case "-":
			case "*":
			case "/":
			
				
				buffer[buffer.length] = $(this).context.textContent;
				justEvaluated = false;
				break;		
							
			case "=":
				// Evaluate
				buffer = [evaluate(buffer)];
				justEvaluated = true;						
				break;
				
			case "Clear":
			  	buffer = [];			  				  
				break;
			  					
		}
		
		
		console.log(buffer);
	;})
	
		
});	    
		