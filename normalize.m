function [outputArg1] = normalize(audioData)


normalized =  audioData / max(abs(audioData));

outputArg1 = normalized;

end

