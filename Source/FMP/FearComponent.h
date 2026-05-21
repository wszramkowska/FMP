// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "FearComponent.generated.h"

/**
 * @brief Broadcast whenever the component recalculates its fear level.
 *
 * @param FearLevel New clamped fear value in the inclusive range [0, 1].
 *
 * @ingroup FMPGameplay
 */
DECLARE_DYNAMIC_MULTICAST_DELEGATE_OneParam(FFearChangedSignature, float, FearLevel);

/**
 * @brief Broadcast when fear reaches the cry threshold and the cooldown allows it.
 *
 * @ingroup FMPGameplay
 */
DECLARE_DYNAMIC_MULTICAST_DELEGATE(FCrySignature);

/**
 * @brief Actor component that raises or lowers a normalized fear value over time.
 *
 * UFearComponent ticks every frame. When the owner is marked as being in darkness,
 * FearLevel rises by FearRiseRate per second; otherwise it falls by FearFallRate per
 * second. The value is clamped between 0 and 1 and broadcast to Blueprint listeners
 * after every update. Reaching the cry threshold triggers OnCry, resets FearLevel to
 * 0.5, and starts a short cooldown before another cry can occur.
 *
 * @note This component does not replicate fear state or events by itself.
 * @note Fear mutation is performed on the game thread during component ticking.
 * @warning The cry cooldown requires a valid World from the owning actor/component.
 * @see FFearChangedSignature
 * @see FCrySignature
 *
 * @ingroup FMPGameplay
 */
UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class FMP_API UFearComponent : public UActorComponent
{
	GENERATED_BODY()

public:	
	/** @brief Creates the component and enables ticking so fear updates over time. */
	UFearComponent();

protected:
	/** @brief Handles component startup; current implementation only calls the parent implementation. */
	virtual void BeginPlay() override;

	/**
	 * @brief Updates fear once per frame.
	 *
	 * @param DeltaTime Time in seconds since the previous tick.
	 * @param TickType Unreal tick phase for this component tick.
	 * @param ThisTickFunction Tick function data supplied by the engine.
	 */
	virtual void TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction) override;

public:	
	
	/** @brief Current normalized fear value, clamped to [0, 1] during UpdateFear. */
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Fear")
	float FearLevel = 0.0f;

	/** @brief Fear added per second while bIsInDarkness is true. */
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Fear")
	float FearRiseRate = 0.025f;

	/** @brief Fear removed per second while bIsInDarkness is false. */
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Fear")
	float FearFallRate = 0.04f;

	/** @brief Whether the component should currently increase fear instead of reducing it. */
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Fear")
	bool bIsInDarkness = true;

	/** @brief Whether the cry threshold can currently fire OnCry. */
	UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Fear")
	bool bCanCry = true;
	
	/** @brief Blueprint event fired after fear is updated or reset by a cry. */
	UPROPERTY(BlueprintAssignable, Category="Fear")
	FFearChangedSignature OnFearChanged;

	/** @brief Blueprint event fired when fear reaches the cry threshold outside cooldown. */
	UPROPERTY(BlueprintAssignable, Category="Fear")
	FCrySignature OnCry;

	/**
	 * @brief Sets whether fear should rise or fall on subsequent ticks.
	 *
	 * @param bDark True to increase fear over time; false to reduce it over time.
	 */
	UFUNCTION(BlueprintCallable, Category="Fear")
	void SetInDarkness(bool bDark);

	/** @return Current normalized fear value. */
	UFUNCTION(BlueprintCallable, Category="Fear")
	float GetFearLevel() const;
	
private:
	/**
	 * @brief Applies per-frame fear drift, clamps the result, broadcasts changes, and checks cry threshold.
	 *
	 * @param DeltaTime Time in seconds to scale rise or fall rates by.
	 */
	void UpdateFear(float DeltaTime);

	/** @brief Fires cry behavior, resets fear, and starts the cooldown timer. */
	void HandleCry();

	/** @brief Timer used to restore bCanCry after HandleCry starts its cooldown. */
	FTimerHandle CryCooldownTimer;
		
};
