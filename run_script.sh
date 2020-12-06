cd /content/darknet

mkdir ./predictions
mkdir ./predictions/Neutral
mkdir ./predictions/Fire
mkdir ./predictions/Smoke

for file in ./image/*.jpg

do
	echo "file: ${file}"

	/content/darknet/darknet detector test data/obj.data cfg/yolov4.cfg ../yolov4_5000.weights ${file} -iou_thresh 0.3 -thresh 0.05

	COUNTER=0

	var="${file%.jpg}"
  	new_prefix="${var##*/}"

	for file_prediction_fire in ./*Fire.jpg;
	do
		if [[ $file_prediction_fire != "./*Fire.jpg" ]]; then
			COUNTER=$(( COUNTER + 1 ))
			echo "Fire: ${file_prediction_fire}"
			no_prefix_name="${file_prediction_fire##*/}"
			mv ${file_prediction_fire} ./predictions/Fire/${new_prefix}_${no_prefix_name}
		fi
	done

	for file_prediction_smoke in ./*Smoke.jpg;
	do
		if [[ $file_prediction_smoke != "./*Smoke.jpg" ]]; then
			COUNTER=$(( COUNTER + 1 ))
			echo "Smoke: ${file_prediction_smoke}"
			no_prefix_name="${file_prediction_smoke##*/}"
			mv ${file_prediction_smoke} ./predictions/Smoke/${new_prefix}_${no_prefix_name}
		fi
	done


	echo "Counter: ${COUNTER}"

	if [[ $COUNTER == 0 ]];
	then
		no_prefix_name="${file##*/}"
		echo "${no_prefix_name}"
		cp ${file} ./predictions/Neutral/${no_prefix_name}
	fi
done

